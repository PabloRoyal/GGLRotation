local Action = _G.Action

local A                = Action

local CONST                                                              = Action.Const

A.Data.ProfileEnabled[Action.CurrentProfile] = true
Action.Data.ProfileUI = {
    DateTime = "v1.7.0 (20 Oct 2024)",

    [2] = {
        [ACTION_CONST_DRUID_GUARDIAN] = {
            {{ E = "LayoutSpace", },},
            
            -- === General Settings ===
            {{E = "Header", L = { ANY = "=== [ General Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AutoBearForm",
                    DBV = true,
                    L = { ANY = "Auto Bear Form" },
                    TT = { ANY = "Automatically enter Bear Form when in combat" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoTaunt",
                    DBV = true,
                    L = { ANY = "Auto Taunt" },
                    TT = { ANY = "Enable automatic Taunt when losing aggro" },
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
                    TT = { ANY = "Enable automatic interrupts" },
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
                    DB = "BarkskinHP",
                    DBV = 60,
                    ONLYOFF = true,
                    L = { ANY = "Barkskin (%)" },
                    TT = { ANY = "Health % to use Barkskin" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "SurvivalInstinctsHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = { ANY = "Survival Instincts (%)" },
                    TT = { ANY = "Health % to use Survival Instincts" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "FrenziedRegenerationHP",
                    DBV = 50,
                    ONLYOFF = true,
                    L = { ANY = "Frenzied Regeneration (%)" },
                    TT = { ANY = "Health % to use Frenzied Regeneration" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "IronfurHP",
                    DBV = 70,
                    ONLYOFF = true,
                    L = { ANY = "Ironfur (%)" },
                    TT = { ANY = "Health % to use Ironfur" },
                    M = {},
                },
            },
            
            -- === Offensive Settings ===
            {{E = "Header", L = { ANY = "=== [ Offensive Settings ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "OffensiveRage",
                    DBV = 50,
                    L = { ANY = "Offensive Rage Threshold" },
                    TT = { ANY = "Use offensive abilities when Rage is above this value" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseIncarnation",
                    DBV = true,
                    L = { ANY = "Use Incarnation: Guardian of Ursoc" },
                    TT = { ANY = "Use Incarnation: Guardian of Ursoc on cooldown" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseBerserk",
                    DBV = true,
                    L = { ANY = "Use Berserk" },
                    TT = { ANY = "Use Berserk on cooldown" },
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
                    DB = "RebirthHP",
                    DBV = 0,
                    ONLYOFF = true,
                    L = { ANY = "Rebirth (%)" },
                    TT = { ANY = "Health % to use Rebirth on dead party members (0 to disable)" },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 100,
                    DB = "IronbarkPartyHP",
                    DBV = 50,
                    ONLYOFF = true,
                    L = { ANY = "Ironbark for Party (%)" },
                    TT = { ANY = "Health % to use Ironbark on party members" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseUrsolsVortex",
                    DBV = true,
                    L = { ANY = "Use Ursol's Vortex" },
                    TT = { ANY = "Automatically use Ursol's Vortex in AoE situations" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseStampedingRoar",
                    DBV = true,
                    L = { ANY = "Use Stampeding Roar" },
                    TT = { ANY = "Use Stampeding Roar for group movement speed" },
                    M = {},
                },
            },
            
            -- === PvP Settings ===
            {{E = "Header", L = { ANY = "=== [ PvP Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "UseMightyBash",
                    DBV = true,
                    L = { ANY = "Use Mighty Bash in PvP" },
                    TT = { ANY = "Use Mighty Bash for CC in PvP situations" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseIncapacitatingRoar",
                    DBV = true,
                    L = { ANY = "Use Incapacitating Roar in PvP" },
                    TT = { ANY = "Use Incapacitating Roar for AoE CC in PvP situations" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "UseSkullBash",
                    DBV = true,
                    L = { ANY = "Use Skull Bash in PvP" },
                    TT = { ANY = "Use Skull Bash to interrupt in PvP situations" },
                    M = {},
                },
            },
            
            -- === Miscellaneous Section ===
            {{E = "Header", L = { ANY = "=== [ Miscellaneous ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "UseMarkOfTheWild",
                    DBV = true,
                    L = { ANY = "Use Mark of the Wild" },
                    TT = { ANY = "Automatically buff party members with Mark of the Wild" },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AutoTarget",
                    DBV = true,
                    L = { ANY = "Auto Target" },
                    TT = { ANY = "Automatically target nearby enemies" },
                    M = {},
                },
            },
        },
    },
}