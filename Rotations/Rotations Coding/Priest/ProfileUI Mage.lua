local Action = _G.Action
local A = Action
local CONST = Action.Const

A.Data.ProfileEnabled[Action.CurrentProfile] = true
Action.Data.ProfileUI = {
    DateTime = "v1.0.0 (22 Oct 2024)",

    [2] = {
        [ACTION_CONST_PRIEST_DISCIPLINE] = {
            {{ E = "LayoutSpace", },},
            
            -- === General Settings ===
            {{E = "Header", L = { ANY = "=== [ General Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AutoAtonement",
                    DBV = true,
                    L = { ANY = "Auto Atonement" },
                    TT = { ANY = "Automatically maintain Atonement on priority targets" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoDispel",
                    DBV = true,
                    L = { ANY = "Auto Dispel" },
                    TT = { ANY = "Enable automatic dispelling of harmful effects" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoAoE",
                    DBV = true,
                    L = { ANY = "Auto AoE" },
                    TT = { ANY = "Enable automatic use of AoE abilities" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoInterrupt",
                    DBV = true,
                    L = { ANY = "Auto Interrupt" },
                    TT = { ANY = "Enable automatic interrupts with Psychic Scream" },
                    M = {},
                },
            },
            
            -- === Defensive Cooldowns Section ===
            {{E = "Header", L = { ANY = "=== [ Defensive Cooldowns ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "PainSuppressionHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = { ANY = "Pain Suppression (%)" },
                    TT = { ANY = "Health % to use Pain Suppression" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "PowerWordBarrierHP",
                    DBV = 50,
                    ONLYOFF = true,
                    L = { ANY = "Power Word: Barrier (%)" },
                    TT = { ANY = "Health % to use Power Word: Barrier" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "RaptureHP",
                    DBV = 70,
                    ONLYOFF = true,
                    L = { ANY = "Rapture (%)" },
                    TT = { ANY = "Health % to use Rapture" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "EmergencyShieldHP",
                    DBV = 40,
                    ONLYOFF = true,
                    L = { ANY = "Emergency Shield (%)" },
                    TT = { ANY = "Health % to use emergency Power Word: Shield" },
                    M = {},
                },
            },
            
            -- === Offensive Settings ===
            {{E = "Header", L = { ANY = "=== [ Offensive Settings ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 6,
                    DB = "MinAtonements",
                    DBV = 3,
                    L = { ANY = "Minimum Atonements" },
                    TT = { ANY = "Minimum Atonements before starting damage rotation" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UsePowerInfusion",
                    DBV = true,
                    L = { ANY = "Use Power Infusion" },
                    TT = { ANY = "Use Power Infusion during ramping phase" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseSpiritShell",
                    DBV = true,
                    L = { ANY = "Use Spirit Shell" },
                    TT = { ANY = "Use Spirit Shell when talented" },
                    M = {},
                },
            },
            
            -- === Party Utility Section ===
            {{E = "Header", L = { ANY = "=== [ Party Utility ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "MassDispelCount",
                    DBV = 2,
                    ONLYOFF = true,
                    L = { ANY = "Mass Dispel Count" },
                    TT = { ANY = "Number of affected targets needed to use Mass Dispel" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "LeapOfFaithHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = { ANY = "Leap of Faith (%)" },
                    TT = { ANY = "Health % to use Leap of Faith on party members" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseEvangelism",
                    DBV = true,
                    L = { ANY = "Use Evangelism" },
                    TT = { ANY = "Use Evangelism to extend Atonements" },
                    M = {},
                },
            },
            
            -- === PvP Settings ===
            {{E = "Header", L = { ANY = "=== [ PvP Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "UsePsychicScream",
                    DBV = true,
                    L = { ANY = "Use Psychic Scream in PvP" },
                    TT = { ANY = "Use Psychic Scream for CC in PvP situations" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseSilence",
                    DBV = true,
                    L = { ANY = "Use Silence in PvP" },
                    TT = { ANY = "Use Silence to interrupt in PvP situations" },
                    M = {},
                },
            },
            
            -- === Miscellaneous Section ===
            {{E = "Header", L = { ANY = "=== [ Miscellaneous ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AutoRamp",
                    DBV = true,
                    L = { ANY = "Auto Ramping" },
                    TT = { ANY = "Automatically start ramping before detected damage events" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoTarget",
                    DBV = true,
                    L = { ANY = "Auto Target" },
                    TT = { ANY = "Automatically target nearby enemies for damage" },
                    M = {},
                },
            },
        },
    },
}