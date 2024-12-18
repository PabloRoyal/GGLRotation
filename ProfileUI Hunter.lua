local Action = _G.Action

local A = Action

local CONST = Action.Const

A.Data.ProfileEnabled[Action.CurrentProfile] = true
Action.Data.ProfileUI = {
    DateTime = "v1.2.0 (27 Sep 2024)",

    [2] = {
        [ACTION_CONST_HUNTER_MARKSMANSHIP] = {
            {{ E = "LayoutSpace", },},
            
            -- === Cooldowns Section ===
            {{E = "Header", L = { ANY = "=== [ Cooldowns ] ===", },},},
            {
                -- Trueshot
                {
                    E = "Checkbox",
                    DB = "UseTrueshot",
                    DBV = true,
                    L = {
                        ANY = "Use Trueshot",
                    },
                    TT = {
                        ANY = "Enable automatic use of Trueshot",
                    },
                    M = {},
                },
                -- Volley
                {
                    E = "Checkbox",
                    DB = "UseVolley",
                    DBV = true,
                    L = {
                        ANY = "Use Volley",
                    },
                    TT = {
                        ANY = "Enable automatic use of Volley",
                    },
                    M = {},
                },
            },
            
            -- === Defensive Section ===
            {{E = "Header", L = { ANY = "=== [ Defensive ] ===", },},},
            {
                -- Exhilaration
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "ExhilarationHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Exhilaration (%)"
                    },
                    TT = {
                        ANY = "Health % to use Exhilaration"
                    },
                    M = {},
                },
                -- Aspect of the Turtle
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "AspectoftheTurtleHP",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Aspect of the Turtle (%)"
                    },
                    TT = {
                        ANY = "Health % to use Aspect of the Turtle"
                    },
                    M = {},
                },
            },
            
            -- === Utility Section ===
            {{E = "Header", L = { ANY = "=== [ Utility ] ===", },},},
            {
                -- Auto Hunter's Mark
                {
                    E = "Checkbox",
                    DB = "AutoHuntersMark",
                    DBV = true,
                    L = {
                        ANY = "Auto Hunter's Mark",
                    },
                    TT = {
                        ANY = "Automatically apply Hunter's Mark",
                    },
                    M = {},
                },
                -- Auto Misdirection
                {
                    E = "Checkbox",
                    DB = "AutoMisdirection",
                    DBV = true,
                    L = {
                        ANY = "Auto Misdirection",
                    },
                    TT = {
                        ANY = "Automatically use Misdirection on tank",
                    },
                    M = {},
                },
            },
            
            -- === AoE Settings ===
            {{E = "Header", L = { ANY = "=== [ AoE Settings ] ===", },},},
            {
                -- AoE Toggle
                {
                    E = "Checkbox",
                    DB = "AoEToggle",
                    DBV = true,
                    L = {
                        ANY = "Use AoE Rotation",
                    },
                    TT = {
                        ANY = "Enable AoE rotation when multiple targets are present",
                    },
                    M = {},
                },
                -- Number of Targets for AoE
                {
                    E = "Slider",
                    MIN = 2,
                    MAX = 10,
                    DB = "AoETargets",
                    DBV = 3,
                    ONLYOFF = true,
                    L = {
                        ANY = "AoE Target Count"
                    },
                    TT = {
                        ANY = "Number of targets to switch to AoE rotation"
                    },
                    M = {},
                },
            },
            
            -- === Interrupt Settings ===
            {{E = "Header", L = { ANY = "=== [ Interrupt Settings ] ===", },},},
            {
                -- Auto Interrupt
                {
                    E = "Checkbox",
                    DB = "AutoInterrupt",
                    DBV = true,
                    L = {
                        ANY = "Auto Interrupt",
                    },
                    TT = {
                        ANY = "Automatically interrupt spells",
                    },
                    M = {},
                },
                -- Interrupt Percentage
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "InterruptAt",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Interrupt At (%)"
                    },
                    TT = {
                        ANY = "Interrupt when spell cast is at this percentage"
                    },
                    M = {},
                },
            },
        },
        
        [ACTION_CONST_HUNTER_BEASTMASTERY] = {
            {{ E = "LayoutSpace", },},
            
            -- === Cooldowns Section ===
            {{E = "Header", L = { ANY = "=== [ Cooldowns ] ===", },},},
            {
                -- Bestial Wrath
                {
                    E = "Checkbox",
                    DB = "UseBestialWrath",
                    DBV = true,
                    L = {
                        ANY = "Use Bestial Wrath",
                    },
                    TT = {
                        ANY = "Enable automatic use of Bestial Wrath",
                    },
                    M = {},
                },
                -- Call of the Wild
                {
                    E = "Checkbox",
                    DB = "UseCalloftheWild",
                    DBV = true,
                    L = {
                        ANY = "Use Call of the Wild",
                    },
                    TT = {
                        ANY = "Enable automatic use of Call of the Wild",
                    },
                    M = {},
                },
            },
            
            -- === Pet Management Section ===
            {{E = "Header", L = { ANY = "=== [ Pet Management ] ===", },},},
            {
                -- Auto Summon Pet
                {
                    E = "Checkbox",
                    DB = "AutoSummonPet",
                    DBV = true,
                    L = {
                        ANY = "Auto Summon Pet",
                    },
                    TT = {
                        ANY = "Automatically summon your pet if it's dead or dismissed",
                    },
                    M = {},
                },
                -- Mend Pet Health Threshold
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 100,
                    DB = "MendPetHP",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mend Pet Health (%)"
                    },
                    TT = {
                        ANY = "Use Mend Pet when pet's health falls below this percentage"
                    },
                    M = {},
                },
            },
            
            -- === Defensive Section ===
            {{E = "Header", L = { ANY = "=== [ Defensive ] ===", },},},
            {
                -- Exhilaration
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "ExhilarationHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Exhilaration (%)"
                    },
                    TT = {
                        ANY = "Health % to use Exhilaration"
                    },
                    M = {},
                },
                -- Aspect of the Turtle
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "AspectoftheTurtleHP",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Aspect of the Turtle (%)"
                    },
                    TT = {
                        ANY = "Health % to use Aspect of the Turtle"
                    },
                    M = {},
                },
            },
            
            -- === Utility Section ===
            {{E = "Header", L = { ANY = "=== [ Utility ] ===", },},},
            {
                -- Auto Hunter's Mark
                {
                    E = "Checkbox",
                    DB = "AutoHuntersMark",
                    DBV = true,
                    L = {
                        ANY = "Auto Hunter's Mark",
                    },
                    TT = {
                        ANY = "Automatically apply Hunter's Mark",
                    },
                    M = {},
                },
                -- Auto Misdirection
                {
                    E = "Checkbox",
                    DB = "AutoMisdirection",
                    DBV = true,
                    L = {
                        ANY = "Auto Misdirection",
                    },
                    TT = {
                        ANY = "Automatically use Misdirection on tank",
                    },
                    M = {},
                },
            },
            
            -- === AoE Settings ===
            {{E = "Header", L = { ANY = "=== [ AoE Settings ] ===", },},},
            {
                -- AoE Toggle
                {
                    E = "Checkbox",
                    DB = "AoEToggle",
                    DBV = true,
                    L = {
                        ANY = "Use AoE Rotation",
                    },
                    TT = {
                        ANY = "Enable AoE rotation when multiple targets are present",
                    },
                    M = {},
                },
                -- Number of Targets for AoE
                {
                    E = "Slider",
                    MIN = 2,
                    MAX = 10,
                    DB = "AoETargets",
                    DBV = 3,
                    ONLYOFF = true,
                    L = {
                        ANY = "AoE Target Count"
                    },
                    TT = {
                        ANY = "Number of targets to switch to AoE rotation"
                    },
                    M = {},
                },
            },
            
            -- === Interrupt Settings ===
            {{E = "Header", L = { ANY = "=== [ Interrupt Settings ] ===", },},},
            {
                -- Auto Interrupt
                {
                    E = "Checkbox",
                    DB = "AutoInterrupt",
                    DBV = true,
                    L = {
                        ANY = "Auto Interrupt",
                    },
                    TT = {
                        ANY = "Automatically interrupt spells",
                    },
                    M = {},
                },
                -- Interrupt Percentage
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "InterruptAt",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Interrupt At (%)"
                    },
                    TT = {
                        ANY = "Interrupt when spell cast is at this percentage"
                    },
                    M = {},
                },
            },
        },
        
        [ACTION_CONST_HUNTER_SURVIVAL] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "Survival settings will be added in a future update", },},},
        },
    },
}