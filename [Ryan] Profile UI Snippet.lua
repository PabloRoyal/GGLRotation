local _G = _G
local Action = _G.Action
local CONST = Action.Const
local ACTION_CONST_ROGUE_OUTLAW = CONST.ROGUE_OUTLAW
local Player = Action.Player
local Listener = Action.Listener
local Create = Action.Create
local GetToggle = Action.GetToggle
local TMW = _G.TMW
local GetSpellTexture = TMW.GetSpellTexture
Action.Ryan = {}
local boolnumber = function (value)
    --@number 1 or 0
    --converts a boolean to 1=true 0=false for use in math operations
    return value and 1 or 0
end
local AoE = {
    E                 = "Checkbox",
    DB                 = "AoE",
    DBV             = true,
    L                 = {
        enUS = "AoE",
        ruRU = "AoE",
    },
    TT                 = {
        enUS = "Enable AoE rotation\n\nRight click: Create macro",
        ruRU = "Включает ротацию для нескольких целей\n\nПравая кнопка мышки: Создать макрос",
    },
    M                 = {},
}
local Mouseover = {
    E                   = "Checkbox",
    DB                  = "mouseover",
    DBV                 = true,
    L = {
        ANY = "Mouse Over\nInterrupts",
    },
    TT = {
        ANY = "Use Mouse Over to Interrupt\nRecommended: ON\n\nRight click: Create macro",
    },
    M                 = {},
}
local MOtotem = {
    E                 = "Checkbox",
    DB                 = "MOTotem",
    DBV             = true,
    L = {
        ANY = "Mouse Over\nTotems",
    },
    TT = {
        ANY = "Use Mouse Over to Target Totems\n\nRight click: Create macro",
    },
    M                 = {},
}
-------------------------------------------------
--Define UI Elements
-------------------------------------------------
local HealthStone = {
    E               = "Slider",
    MIN             = -1,
    MAX             = 100,
    DB              = "HealthStone",
    DBV             = 100,
    ONOFF           = true,
    L               =   {
                            ANY = "Health Stone\nor Potion",
                        },
    TT              =   {
                            ANY = "\n\nRight click: Create macro",
                        },
    M               =   {},
}
local oocStealth = {
    E                 = "Checkbox",
    DB                 = "OOCStealth",
    DBV             = true,
    L                 = {
        enUS = "OOC Stealth",
        ruRU = "Скрытность",
    },
    TT                 = {
        enUS = "Enable OOC Stealth\n\nRight click: Create macro",
        ruRU = "Включает ротацию для нескольких целей\n\nПравая кнопка мышки: Создать макрос",
    },
    M                 = {},
}
local PoisonHeader = { -- [2] Poisons
{
    E                 = "Header",
    L                 = {ANY = "Poisons"},
},
}
local NonLethalPoisons = {
    E = "Dropdown",
    OT = {
        { text = Action.GetSpellInfo(3408), value = 1 }, --Crippling
        { text = "Numbing or Atrophic", value = 2 }, --Numbing or Atrophic
    },
    DB = "NonLethalPoison",
    DBV = 2,
    L = {ANY = "Non-Lethal Poison"},
    TT = {ANY = "Select the non-lethal poison the rotation should always maintain\n\nRight click: Create macro"},
    M = {},
}
local LethalPoisons = {
        E = "Dropdown",
        OT = {
            { text = Action.GetSpellInfo(315584), value = 1 }, --instant
            { text = Action.GetSpellInfo(8679), value = 2 }, --wound
        },
        DB = "LethalPoison",
        DBV = 1,
        L = {ANY = "Lethal Poison"},
        TT = {ANY = "Select the lethal poison the rotation should always maintain\n\nRight click: Create macro"},
        M = {},
}
local Poisons2 = { -- first row
NonLethalPoisons,
LethalPoisons,
}
local SelfDefense = { --Header
    {
        E                 = "Header",
        L                 = {
                                enUS = "Self Defense",
                                ruRU = "Самооборона",
                            },
    },
}
local SelfDefense3 = { -- second row
    HealthStone,
}
local LayoutConfigOptions = { gutter = 6, padding = { left = 5, right = 5 } }
Action.Data.ProfileEnabled[Action.CurrentProfile]             = true
Action.Data.ProfileUI                                     = {
    DateTime = "v6.0 (2024.3.24)",
    [2] = {
        [ACTION_CONST_ROGUE_OUTLAW] = {
            LayoutOptions = LayoutConfigOptions,
            {AoE,
            Mouseover,
            MOtotem,},
            {
                oocStealth,
            },
            PoisonHeader,
            Poisons2,
            SelfDefense,
            SelfDefense3,
        },
    },
}
-------------------------------------------------------------------------------
-- Ryan Rogue Functions
-------------------------------------------------------------------------------
local EchoingBuffs = {
    [0] = 0, --added to simplyfiy checks
    [1] = 0,
    [2] = 323558,
    [3] = 323559,
    [4] = 323560,
    [5] = 354838,
    [6] = 0,
    [7] = 0,
    [8] = 0,
}
function Action.EchoingBuffMatch(next)
    local comboPoints = Player:ComboPoints() + boolnumber(next)
        return Action.Unit("player"):HasBuffs(EchoingBuffs[comboPoints]) > 0
end
--------------------------------------------------------------
--Global Definitons
-----------------------------------------------------------------
Action.Ryan.Rogue={
    rtb_container_duration = 30,
    rtb_container_start_time = 0,
    rtb_container_remaining_time = 0,
}
--Disable Auto Burst
local function disableAutoBurst()
    if GetToggle(1, "Burst") == "Auto" then
        Action.SetToggle({1, "Burst"}, "Everything")
        Action.Print("Auto Burst is not Compatible with Ryan Rotations")
    end
end
disableAutoBurst()
Listener:Add("ACTION_EVENT_DISABLE_BURST", "PLAYER_ENTERING_WORLD", disableAutoBurst)
Listener:Add("ACTION_EVENT_DISABLE_BURST", "PLAYER_REGEN_ENABLED", disableAutoBurst)
Listener:Add("ACTION_EVENT_DISABLE_BURST", "PLAYER_EQUIPMENT_CHANGED", disableAutoBurst)
Listener:Add("ACTION_EVENT_DISABLE_BURST", "PLAYER_SPECIALIZATION_CHANGED", disableAutoBurst)
-----------------------------------------------------------------
--SPELL TABLES
------------------------------------------------------------------
Action[ACTION_CONST_ROGUE_OUTLAW] = {
    -- Racials
    ArcaneTorrent = Create({ Type = "Spell", ID = 25046}),
    BloodFury = Create({ Type = "Spell", ID = 20572}),
    Fireblood = Create({ Type = "Spell", ID = 265221}),
    AncestralCall = Create({ Type = "Spell", ID = 274738}),
    Berserking = Create({ Type = "Spell", ID = 26297}),
    ArcanePulse = Create({ Type = "Spell", ID = 260364}),
    QuakingPalm = Create({ Type = "Spell", ID = 107079}),
    Haymaker = Create({ Type = "Spell", ID = 287712}),
    WarStomp = Create({ Type = "Spell", ID = 20549}),
    BullRush = Create({ Type = "Spell", ID = 255654}),
    BagofTricks = Create({ Type = "Spell", ID = 312411}),
    GiftofNaaru = Create({ Type = "Spell", ID = 59544 }),
    LightsJudgment = Create({ Type = "Spell", ID = 255647}),
    Shadowmeld = Create({ Type = "Spell", ID = 58984}), -- usable in Action Core
    Stoneform = Create({ Type = "Spell", ID = 20594}),
    WilloftheForsaken = Create({ Type = "Spell", ID = 7744}), -- usable in Action Core
    EscapeArtist = Create({ Type = "Spell", ID = 20589}), -- usable in Action Core
    RogueClass = Create({ Type = "Spell", ID = 401126,Hidden = true}),
    --Rogue Buffs
    VanishStealth = Create({ Type = "Spell", ID = 11327,Hidden = true}),        --buff from vanish
    SepsisStealth = Create({ Type = "Spell", ID = 347037,Hidden = true}),       --buff that enables stealth abilities
    SubterfugeStealth = Create({ Type = "Spell", ID = 115191,Hidden = true}),       --buff from being stealthed?
    --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    --Rogue Baseline
    Ambush = Create({ Type = "Spell", ID = 8676}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    Eviscerate = Create({ Type = "Spell", ID = 196819}),
    InstantPoison = Create({ Type = "Spell", ID = 315584}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    SliceAndDice = Create({ Type = "Spell", ID = 315496}),
    Sprint = Create({ Type = "Spell", ID = 2983}),
    Stealth = Create({ Type = "Spell", ID = 1784}),
    ShroudofConcealment = Create({ Type = "Spell", ID = 114018}),
    PickLock = Create({ Type = "Spell", ID = 1804}),
    KidneyShot = Create({ Type = "Spell", ID = 408}),
    PickPocket = Create({ Type = "Spell", ID = 921}),
    Vanish = Create({ Type = "Spell", ID = 1856}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    Distract = Create({ Type = "Spell", ID = 1725}),
    --Rogue Talents
    --Tier 1
    Shiv = Create({ Type = "Spell", ID = 5938}),
    Blind = Create({ Type = "Spell", ID = 2094}),
    Sap = Create({ Type = "Spell", ID = 6770}),
    --Tier 2
    Evasion = Create({ Type = "Spell", ID = 5277}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    CloakofShadows = Create({ Type = "Spell", ID = 31224}),
    --Tier 3
    MasterPoisoner = Create({ Type = "Spell", ID = 378436, isTalent = true, Hidden = true}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    AtrophicPoison = Create({ Type = "Spell", ID = 381637}),
    NimbleFingers = Create({ Type = "Spell", ID = 378427, isTalent = true, Hidden = true}),
    Gouge = Create({ Type = "Spell", ID = 1776}),
    BlackJack = Create({ Type = "Spell", ID = 379005, isTalent = true, Hidden = true}),
    TricksoftheTrade = Create({ Type = "Spell", ID = 57934}),
    Shadowrunner = Create({ Type = "Spell", ID = 378807, isTalent = true, Hidden = true}),
    --Tier 4
    ImprovedWoundPoison = Create({ Type = "Spell", ID = 319066, isTalent = true, Hidden = true}),
    FleetFooted = Create({ Type = "Spell", ID = 378813, isTalent = true, Hidden = true}),
    IronStomach = Create({ Type = "Spell", ID = 193546, isTalent = true, Hidden = true}),
    ImprovedSprint = Create({ Type = "Spell", ID = 231691, isTalent = true, Hidden = true}),
    PreyontheWeak = Create({ Type = "Spell", ID = 131511, isTalent = true, Hidden = true}),
    ShadowStep = Create({ Type = "Spell", ID = 36554}),
    Subterfuge  = Create({ Type = "Spell", ID = 108208, isTalent = true, Hidden = true}),
    SubterfugeBuff  = Create({ Type = "Spell", ID = 115192, isTalent = true, Hidden = true}), --buff from subterfuge
    --Tier 5
    VirulentPoisons = Create({ Type = "Spell", ID = 381543, isTalent = true, Hidden = true}),
    DeadenedNerves = Create({ Type = "Spell", ID = 231719, isTalent = true, Hidden = true}),
    Elusiveness = Create({ Type = "Spell", ID = 79008, isTalent = true, Hidden = true}),
    CheatDeath = Create({ Type = "Spell", ID = 31230, isTalent = true, Hidden = true}),
    RushedSetup = Create({ Type = "Spell", ID = 378803, isTalent = true, Hidden = true}),
    TightSpender = Create({ Type = "Spell", ID = 381621, isTalent = true, Hidden = true}),
    --Tier 6
    DeadlyPrecision = Create({ Type = "Spell", ID = 381542, isTalent = true, Hidden = true}),
    ThiefsVersatility = Create({ Type = "Spell", ID = 381619, isTalent = true, Hidden = true}),
    Nightstalker = Create({ Type = "Spell", ID = 14062, isTalent = true, Hidden = true}),
    --Tier 7
    Vigor = Create({ Type = "Spell", ID = 14983, isTalent = true, Hidden = true}),
    AcrobaticStrikes = Create({ Type = "Spell", ID = 196924, isTalent = true, Hidden = true}),
    ImprovedAmbush = Create({ Type = "Spell", ID = 381620, isTalent = true, Hidden = true}),
    --Tier 8
    LeechingPoison = Create({ Type = "Spell", ID = 280716, isTalent = true, Hidden = true}),
    LeechingPoisonBuff = Create({ Type = "Spell", ID = 108211, Hidden = true}),
    Lethality = Create({ Type = "Spell", ID = 382238, isTalent = true, Hidden = true}),
    Recuperator = Create({ Type = "Spell", ID = 378996, isTalent = true, Hidden = true}),
    Alacrity = Create({ Type = "Spell", ID = 193539, isTalent = true, Hidden = true}),
    SoothingDarkness = Create({ Type = "Spell", ID = 393970, isTalent = true, Hidden = true}),
    --Tier 9
    SealFate = Create({ Type = "Spell", ID = 14190, isTalent = true, Hidden = true}),
    ColdBlood = Create({ Type = "Spell", ID = 382245}),
    EchoingReprimand = Create({ Type = "Spell", ID = 385616}),
    DeeperStratagem  = Create({ Type = "Spell", ID = 193531, isTalent = true, Hidden = true}),
    FindWeakness = Create({ Type = "Spell", ID = 91023, isTalent = true, Hidden = true}),
    FindWeaknessDebuff = Create({ Type = "Spell", ID = 316220, isTalent = true, Hidden = true}),
    --Tier 10
    ThistleTea = Create({ Type = "Spell", ID = 381623}),
    ResoundingClarity = Create({ Type = "Spell", ID = 381622, isTalent = true, Hidden = true}),
    Reverberation  = Create({ Type = "Spell", ID = 394332, isTalent = true, Hidden = true}),
    ShadowDance = Create({ Type = "Spell", ID = 185313}),
    ShadowDanceBuff = Create({ Type = "Spell", ID = 185422, Hidden = true}),
    --Trinkets
    EruptingSpearFragment  = Create({ Type = "Trinket", ID = 193769, Hidden = true}), --Trinket that requires ground target
    GlobeofJaggedIce  = Create({ Type = "Trinket", ID = 193732, Hidden = true}), --requires debuff on enemies
    SkeweringCold  = Create({ Type = "Spell", ID = 388929, Hidden = true}), --enemy debuff from GlobeofJaggedIce
    PrimalRitualShell = Create({ Type = "Trinket", ID = 200563, Hidden = true}), --Trinket requires specific world spot to use
    ManicGrieftorch =  Create({ Type = "Trinket", ID = 194308, Hidden = true}), --requires casting and different logic
    StormEatersBoon =  Create({ Type = "Trinket", ID = 194302, Hidden = true}), --Roots player and should have some minimum count of targets
    BeacontotheBeyond =  Create({ Type = "Trinket", ID = 203963, Hidden = true}), --Cast bar with special logic
    DragonfireBombDispenser =  Create({ Type = "Trinket", ID = 202610, Hidden = true}), --needs to ignore TTD, check other trinket, and AOE logic
    DragonfireBombDispenserSpell =  Create({ Type = "Spell", ID = 408671, Hidden = true}), --needs to ignore TTD, check other trinket, and AOE logic
    OminousChromaticEssence =  Create({ Type = "Trinket", ID = 203729, Hidden = true}), --No on use
    WitherbarksBranch =  Create({ Type = "Trinket", ID = 109999, Hidden = true}), --Cast bar with special logic
    AshesOfTheEmbersoul =  Create({ Type = "Trinket", ID = 207167, Hidden = true}), --Cast bar with special logic
    --TODO PVP???? verify specs
    Dismantle  = Create({ Type = "Spell", ID = 207777}),
    SmokeBomb = Create({ Type = "Spell", ID = 212182}),
    DeathFromAbove = Create({ Type = "Spell", ID = 269513}),
    --RollTheBonesbuff
    Broadside = Create({ Type = "Spell", ID = 193356, Hidden = true}),
    BuriedTreasure = Create({ Type = "Spell", ID = 199600, Hidden = true}),
    GrandMelee = Create({ Type = "Spell", ID = 193358, Hidden = true}),
    RuthlessPrecision = Create({ Type = "Spell", ID = 193357, Hidden = true}),
    SkullAndCrossbones = Create({ Type = "Spell", ID = 199603, Hidden = true}),
    TrueBearing = Create({ Type = "Spell", ID = 193359, Hidden = true}),
    --Outlaw Rogue Baseline
    PistolShot = Create({ Type = "Spell", ID = 185763}),
    Dispatch = Create({ Type = "Spell", ID = 2098}),
    SinisterStrike = Create({ Type = "Spell", ID = 1752}),
    BetweenTheEyes = Create({ Type = "Spell", ID = 315341}),
    --Outlaw Talents
    --Tier 1
    Opportunity = Create({ Type = "Spell", ID = 195627, isTalent = true, Hidden = true}), --279876
    BladeFlurry = Create({ Type = "Spell", ID = 13877}),
    --Tier 2
    GrapplingHook = Create({ Type = "Spell", ID = 195457}),
    AdrenalineRush = Create({ Type = "Spell", ID = 186286}),
    AdrenalineRushBuff = Create({ Type = "Spell", ID = 13750, Hidden = true}), --buff from AdrenalineRush
    DeftManeuvers = Create({ Type = "Spell", ID = 381878, isTalent = true, Hidden = true}),
    --Tier 4
    Ruthlessness = Create({ Type = "Spell", ID = 14161, isTalent = true, Hidden = true}),
    ImprovedBetweenTheEyes = Create({ Type = "Spell", ID = 235484, isTalent = true, Hidden = true}),
    --Tier 5
    HeavyHitter = Create({ Type = "Spell", ID = 381885, isTalent = true, Hidden = true}),
    RollTheBones = Create({ Type = "Spell", ID = 315508}),
    QuickDraw = Create({ Type = "Spell", ID = 196938, isTalent = true, Hidden = true}),
    --Tier 6
    Audacity = Create({ Type = "Spell", ID = 381845, isTalent = true, Hidden = true}),
    AudacityBuff = Create({ Type = "Spell", ID = 386270, Hidden = true}), -- Buff from Audacity
    LoadedDice = Create({ Type = "Spell", ID = 256170, isTalent = true, Hidden = true}),
    LoadedDiceBuff = Create({ Type = "Spell", ID = 256171, Hidden = true}),
    --Tier 7
    CountTheOdds = Create({ Type = "Spell", ID = 381982, isTalent = true, Hidden = true}),
    --Tier 8
    UnderhandedUpperHand = Create({ Type = "Spell", ID = 424044, isTalent = true, Hidden = true}),
    Sepsis = Create({ Type = "Spell", ID = 385408, FixedTexture = GetSpellTexture(269513)}),
    GhostlyStrike = Create({ Type = "Spell", ID = 196937}),
    BladeRush = Create({ Type = "Spell", ID = 271877}),
    ImprovedAdrenalineRush = Create({ Type = "Spell", ID = 395422, isTalent = true, Hidden = true}),
    KillingSpree = Create({ Type = "Spell", ID = 51690}),
    FanTheHammer = Create({ Type = "Spell", ID = 381846, isTalent = true, Hidden = true}),
    --Tier 10
    HiddenOpportunity = Create({ Type = "Spell", ID = 383281, isTalent = true, Hidden = true}),
    KeepItRolling = Create({ Type = "Spell", ID = 381989}),
    GreenskinsWickers = Create({ Type = "Spell", ID = 386823, isTalent = true, Hidden = true}),
    GreenskinsWickersBuff = Create({ Type = "Spell", ID = 394131, Hidden = true}), --buff from GSW talent
    Crackshot = Create({ Type = "Spell", ID = 423703, isTalent = true, Hidden = true}),
    --Tier set 30
    Soulripper = Create({ Type = "Spell", ID = 409606, Hidden = true}), -- buff increases Agi 5%
    Soulrip = Create({ Type = "Spell", ID = 409604, Hidden = true}), -- debuff dot
}
--Create Tier Sets
Player:AddTier("Tier30", { 202497, 202498, 202495, 202500, 202496 })
Player:AddTier("Tier31", { 207236, 207234, 207239, 207237, 207235 })